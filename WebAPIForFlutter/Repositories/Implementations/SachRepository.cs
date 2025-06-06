using Microsoft.EntityFrameworkCore;
using WebAPIForFlutter.Models;
using WebAPIForFlutter.Repositories.Interfaces;

namespace WebAPIForFlutter.Repositories.Implementations;

public class SachRepository : ISachRepository
{
    private readonly BookPdfContext _context;

    public SachRepository(BookPdfContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<Sach>> GetAllAsync()
    {
        return await _context.Saches
            .Include(s => s.MaLoaiNavigation)
            .ToListAsync();
    }

    public async Task<Sach?> GetByIdAsync(string id)
    {
        return await _context.Saches
            .Include(s => s.MaLoaiNavigation)
            .FirstOrDefaultAsync(s => s.MaSach == id);
    }

    public async Task<IEnumerable<Sach>> SearchAsync(string searchTerm)
    {
        searchTerm = searchTerm.ToLower();
        return await _context.Saches
            .Include(s => s.MaLoaiNavigation)
            .Where(s => 
                (s.TenSach != null && s.TenSach.ToLower().Contains(searchTerm)) ||
                (s.TacGia != null && s.TacGia.ToLower().Contains(searchTerm)) ||
                (s.MoTa != null && s.MoTa.ToLower().Contains(searchTerm))
            )
            .ToListAsync();
    }

    public async Task<IEnumerable<Sach>> GetPagedAsync(int page, int pageSize)
    {
        return await _context.Saches
            .Include(s => s.MaLoaiNavigation)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }

    public async Task<int> GetTotalCountAsync()
    {
        return await _context.Saches.CountAsync();
    }

    public async Task<Sach> CreateAsync(Sach sach)
    {
        _context.Saches.Add(sach);
        await _context.SaveChangesAsync();
        return sach;
    }

    public async Task<Sach> UpdateAsync(Sach sach)
    {
        _context.Entry(sach).State = EntityState.Modified;
        await _context.SaveChangesAsync();
        return sach;
    }

    public async Task DeleteAsync(string id)
    {
        var sach = await _context.Saches.FindAsync(id);
        if (sach != null)
        {
            _context.Saches.Remove(sach);
            await _context.SaveChangesAsync();
        }
    }
} 