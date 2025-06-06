using WebAPIForFlutter.DTOs;

namespace WebAPIForFlutter.Services.Interfaces;

public interface ITheloaiService
{
    Task<IEnumerable<TheloaiDTO>> GetAllAsync();
    Task<TheloaiDTO?> GetByIdAsync(string id);
    Task<TheloaiDTO> CreateAsync(TheloaiCreateDTO theloaiDto);
    Task<TheloaiDTO> UpdateAsync(string id, TheloaiUpdateDTO theloaiDto);
    Task DeleteAsync(string id);
} 