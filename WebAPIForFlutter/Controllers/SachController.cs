using Microsoft.AspNetCore.Mvc;
using WebAPIForFlutter.DTOs;
using WebAPIForFlutter.Services.Interfaces;

namespace WebAPIForFlutter.Controllers;

[ApiController]
[Route("api/[controller]")]
public class SachController : ControllerBase
{
    private readonly ISachService _sachService;

    public SachController(ISachService sachService)
    {
        _sachService = sachService;
    }

    // GET: api/Sach
    [HttpGet]
    public async Task<ActionResult<IEnumerable<SachDTO>>> GetSachs()
    {
        var saches = await _sachService.GetAllAsync();
        return Ok(saches);
    }

    // GET: api/Sach/5
    [HttpGet("{id}")]
    public async Task<ActionResult<SachDTO>> GetSach(string id)
    {
        var sach = await _sachService.GetByIdAsync(id);
        if (sach == null)
        {
            return NotFound();
        }
        return sach;
    }

    // POST: api/Sach
    [HttpPost]
    public async Task<ActionResult<SachDTO>> CreateSach(SachCreateDTO sachDto)
    {
        var createdSach = await _sachService.CreateAsync(sachDto);
        return CreatedAtAction(nameof(GetSach), new { id = createdSach.Id }, createdSach);
    }

    // PUT: api/Sach/5
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateSach(string id, SachUpdateDTO sachDto)
    {
        try
        {
            await _sachService.UpdateAsync(id, sachDto);
            return NoContent();
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }

    // DELETE: api/Sach/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteSach(string id)
    {
        try
        {
            await _sachService.DeleteAsync(id);
            return NoContent();
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }

    // POST: api/Sach/5/increment-view
    [HttpPost("{id}/increment-view")]
    public async Task<ActionResult<SachDTO>> IncrementViewCount(string id)
    {
        try
        {
            var updatedSach = await _sachService.IncrementViewCountAsync(id);
            return Ok(updatedSach);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }

    // POST: api/Sach/5/increment-like
    [HttpPost("{id}/increment-like")]
    public async Task<ActionResult<SachDTO>> IncrementLikeCount(string id)
    {
        try
        {
            var updatedSach = await _sachService.IncrementLikeCountAsync(id);
            return Ok(updatedSach);
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
} 