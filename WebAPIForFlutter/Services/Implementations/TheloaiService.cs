using WebAPIForFlutter.DTOs;
using WebAPIForFlutter.Models;
using WebAPIForFlutter.Repositories.Interfaces;
using WebAPIForFlutter.Services.Interfaces;

namespace WebAPIForFlutter.Services.Implementations;

public class TheloaiService : ITheloaiService
{
    private readonly ITheloaiRepository _theloaiRepository;

    public TheloaiService(ITheloaiRepository theloaiRepository)
    {
        _theloaiRepository = theloaiRepository;
    }

    public async Task<IEnumerable<TheloaiDTO>> GetAllAsync()
    {
        var theloais = await _theloaiRepository.GetAllAsync();
        return theloais.Select(MapToDTO);
    }

    public async Task<TheloaiDTO?> GetByIdAsync(string id)
    {
        var theloai = await _theloaiRepository.GetByIdAsync(id);
        return theloai != null ? MapToDTO(theloai) : null;
    }

    public async Task<TheloaiDTO> CreateAsync(TheloaiCreateDTO theloaiDto)
    {
        var theloai = new Theloai
        {
            MaLoai = theloaiDto.Id,
            TenLoai = theloaiDto.Name
        };

        var createdTheloai = await _theloaiRepository.CreateAsync(theloai);
        return MapToDTO(createdTheloai);
    }

    public async Task<TheloaiDTO> UpdateAsync(string id, TheloaiUpdateDTO theloaiDto)
    {
        var existingTheloai = await _theloaiRepository.GetByIdAsync(id);
        if (existingTheloai == null)
            throw new KeyNotFoundException($"Theloai with ID {id} not found");

        existingTheloai.TenLoai = theloaiDto.Name;

        var updatedTheloai = await _theloaiRepository.UpdateAsync(existingTheloai);
        return MapToDTO(updatedTheloai);
    }

    public async Task DeleteAsync(string id)
    {
        await _theloaiRepository.DeleteAsync(id);
    }

    private static TheloaiDTO MapToDTO(Theloai theloai)
    {
        return new TheloaiDTO
        {
            Id = theloai.MaLoai,
            Name = theloai.TenLoai
        };
    }

    private static string GenerateMaLoai()
    {
        return "TL" + DateTime.Now.ToString("yyyyMMddHHmmss");
    }
} 