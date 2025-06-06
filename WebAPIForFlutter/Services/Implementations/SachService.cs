using Microsoft.EntityFrameworkCore;
using WebAPIForFlutter.DTOs;
using WebAPIForFlutter.Models;
using WebAPIForFlutter.Repositories.Interfaces;
using WebAPIForFlutter.Services.Interfaces;

namespace WebAPIForFlutter.Services.Implementations;

public class SachService : ISachService
{
    private readonly ISachRepository _sachRepository;

    public SachService(ISachRepository sachRepository)
    {
        _sachRepository = sachRepository;
    }

    public async Task<IEnumerable<SachDTO>> GetAllAsync()
    {
        var saches = await _sachRepository.GetAllAsync();
        return saches.Select(MapToDTO);
    }

    public async Task<SachDTO?> GetByIdAsync(string id)
    {
        var sach = await _sachRepository.GetByIdAsync(id);
        return sach != null ? MapToDTO(sach) : null;
    }

    private async Task<string> GenerateNextId()
    {
        var allSaches = await _sachRepository.GetAllAsync();
        var lastSach = allSaches
            .Where(s => s.MaSach.StartsWith("SH"))
            .OrderByDescending(s => s.MaSach)
            .FirstOrDefault();

        if (lastSach == null)
        {
            return "SH001";
        }

        // Lấy số từ ID cuối cùng (ví dụ: "SH001" -> 1)
        var lastNumber = int.Parse(lastSach.MaSach.Substring(2));
        var nextNumber = lastNumber + 1;
        
        // Format số với 3 chữ số (ví dụ: 1 -> "001")
        return $"SH{nextNumber:D3}";
    }

    public async Task<SachDTO> CreateAsync(SachCreateDTO sachDto)
    {
        var sach = new Sach
        {
            MaSach = await GenerateNextId(),
            TenSach = sachDto.Title,
            TacGia = sachDto.Author,
            MoTa = sachDto.Description,
            MaLoai = sachDto.CategoryId,
            LinkAnhBia = sachDto.CoverUrl,
            Pdfurl = sachDto.PdfUrl,
            NgayDuaLen = DateOnly.FromDateTime(DateTime.Now),
            Sotrang = sachDto.PageCount,
            Namxuatban = sachDto.PublicationYear,
            LuotXem = 0,
            LuotLike = 0
        };

        var createdSach = await _sachRepository.CreateAsync(sach);
        return MapToDTO(createdSach);
    }

    public async Task<SachDTO> UpdateAsync(string id, SachUpdateDTO sachDto)
    {
        var existingSach = await _sachRepository.GetByIdAsync(id);
        if (existingSach == null)
            throw new KeyNotFoundException($"Sach with ID {id} not found");

        // Update only non-null properties
        if (sachDto.Title != null)
            existingSach.TenSach = sachDto.Title;
        if (sachDto.Author != null)
            existingSach.TacGia = sachDto.Author;
        if (sachDto.Description != null)
            existingSach.MoTa = sachDto.Description;
        if (sachDto.CategoryId != null)
            existingSach.MaLoai = sachDto.CategoryId;
        if (sachDto.CoverUrl != null)
            existingSach.LinkAnhBia = sachDto.CoverUrl;
        if (sachDto.PdfUrl != null)
            existingSach.Pdfurl = sachDto.PdfUrl;
        if (sachDto.PageCount.HasValue)
            existingSach.Sotrang = sachDto.PageCount;
        if (sachDto.PublicationYear.HasValue)
            existingSach.Namxuatban = sachDto.PublicationYear;

        var updatedSach = await _sachRepository.UpdateAsync(existingSach);
        return MapToDTO(updatedSach);
    }

    public async Task DeleteAsync(string id)
    {
        await _sachRepository.DeleteAsync(id);
    }

    public async Task<SachDTO> IncrementViewCountAsync(string id)
    {
        var sach = await _sachRepository.GetByIdAsync(id);
        if (sach == null)
            throw new KeyNotFoundException($"Sach with ID {id} not found");

        sach.LuotXem = (sach.LuotXem ?? 0) + 1;
        var updatedSach = await _sachRepository.UpdateAsync(sach);
        return MapToDTO(updatedSach);
    }

    public async Task<SachDTO> IncrementLikeCountAsync(string id)
    {
        var sach = await _sachRepository.GetByIdAsync(id);
        if (sach == null)
            throw new KeyNotFoundException($"Sach with ID {id} not found");

        sach.LuotLike = (sach.LuotLike ?? 0) + 1;
        var updatedSach = await _sachRepository.UpdateAsync(sach);
        return MapToDTO(updatedSach);
    }

    private static SachDTO MapToDTO(Sach sach)
    {
        return new SachDTO
        {
            Id = sach.MaSach,
            Title = sach.TenSach,
            Author = sach.TacGia,
            Description = sach.MoTa,
            CoverUrl = sach.LinkAnhBia,
            PdfUrl = sach.Pdfurl,
            UploadDate = sach.NgayDuaLen?.ToDateTime(TimeOnly.MinValue) ?? DateTime.Now,
            PageCount = sach.Sotrang ?? 0,
            PublicationYear = sach.Namxuatban ?? 0,
            ViewCount = sach.LuotXem ?? 0,
            LikeCount = sach.LuotLike ?? 0,
            Category = sach.MaLoaiNavigation != null ? new TheloaiDTO
            {
                Id = sach.MaLoaiNavigation.MaLoai,
                Name = sach.MaLoaiNavigation.TenLoai
            } : null
        };
    }
} 