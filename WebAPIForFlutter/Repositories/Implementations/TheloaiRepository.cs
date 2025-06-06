using Microsoft.EntityFrameworkCore;
using WebAPIForFlutter.Models;
using WebAPIForFlutter.Repositories.Interfaces;

namespace WebAPIForFlutter.Repositories.Implementations;

public class TheloaiRepository : ITheloaiRepository
{
    private readonly BookPdfContext _context;

    public TheloaiRepository(BookPdfContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<Theloai>> GetAllAsync()
    {
        return await _context.Theloais.ToListAsync();
    }

    public async Task<Theloai?> GetByIdAsync(string id)
    {
        return await _context.Theloais.FindAsync(id);
    }

    public async Task<Theloai> CreateAsync(Theloai theloai)
    {
        _context.Theloais.Add(theloai);
        await _context.SaveChangesAsync();
        return theloai;
    }

    public async Task<Theloai> UpdateAsync(Theloai theloai)
    {
        _context.Entry(theloai).State = EntityState.Modified;
        await _context.SaveChangesAsync();
        return theloai;
    }

    public async Task DeleteAsync(string id)
    {
        var theloai = await _context.Theloais.FindAsync(id);
        if (theloai != null)
        {
            _context.Theloais.Remove(theloai);
            await _context.SaveChangesAsync();
        }
    }
} 