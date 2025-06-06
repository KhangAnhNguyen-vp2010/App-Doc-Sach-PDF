using WebAPIForFlutter.Models;

namespace WebAPIForFlutter.Repositories.Interfaces;

public interface ISachRepository
{
    Task<IEnumerable<Sach>> GetAllAsync();
    Task<Sach?> GetByIdAsync(string id);
    Task<IEnumerable<Sach>> SearchAsync(string searchTerm);
    Task<IEnumerable<Sach>> GetPagedAsync(int page, int pageSize);
    Task<int> GetTotalCountAsync();
    Task<Sach> CreateAsync(Sach sach);
    Task<Sach> UpdateAsync(Sach sach);
    Task DeleteAsync(string id);
} 