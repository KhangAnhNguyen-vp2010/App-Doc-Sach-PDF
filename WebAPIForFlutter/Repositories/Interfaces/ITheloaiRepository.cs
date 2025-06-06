using WebAPIForFlutter.Models;

namespace WebAPIForFlutter.Repositories.Interfaces;

public interface ITheloaiRepository
{
    Task<IEnumerable<Theloai>> GetAllAsync();
    Task<Theloai?> GetByIdAsync(string id);
    Task<Theloai> CreateAsync(Theloai theloai);
    Task<Theloai> UpdateAsync(Theloai theloai);
    Task DeleteAsync(string id);
} 