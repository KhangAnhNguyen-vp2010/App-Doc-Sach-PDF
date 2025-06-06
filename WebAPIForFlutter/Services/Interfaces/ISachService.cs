using WebAPIForFlutter.DTOs;

namespace WebAPIForFlutter.Services.Interfaces;

public interface ISachService
{
    Task<IEnumerable<SachDTO>> GetAllAsync();
    Task<SachDTO?> GetByIdAsync(string id);
    Task<SachDTO> CreateAsync(SachCreateDTO sachDto);
    Task<SachDTO> UpdateAsync(string id, SachUpdateDTO sachDto);
    Task DeleteAsync(string id);
    Task<SachDTO> IncrementViewCountAsync(string id);
    Task<SachDTO> IncrementLikeCountAsync(string id);
} 