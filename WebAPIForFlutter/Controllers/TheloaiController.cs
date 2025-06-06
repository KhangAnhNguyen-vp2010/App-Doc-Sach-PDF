using Microsoft.AspNetCore.Mvc;
using WebAPIForFlutter.DTOs;
using WebAPIForFlutter.Services.Interfaces;

namespace WebAPIForFlutter.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TheloaiController : ControllerBase
{
    private readonly ITheloaiService _theloaiService;

    public TheloaiController(ITheloaiService theloaiService)
    {
        _theloaiService = theloaiService;
    }

    // GET: api/Theloai
    [HttpGet]
    public async Task<ActionResult<IEnumerable<TheloaiDTO>>> GetTheloais()
    {
        var theloais = await _theloaiService.GetAllAsync();
        return Ok(theloais);
    }

    // GET: api/Theloai/5
    [HttpGet("{id}")]
    public async Task<ActionResult<TheloaiDTO>> GetTheloai(string id)
    {
        var theloai = await _theloaiService.GetByIdAsync(id);
        if (theloai == null)
        {
            return NotFound();
        }
        return theloai;
    }

    // POST: api/Theloai
    [HttpPost]
    public async Task<ActionResult<TheloaiDTO>> CreateTheloai(TheloaiCreateDTO theloaiDto)
    {
        var createdTheloai = await _theloaiService.CreateAsync(theloaiDto);
        return CreatedAtAction(nameof(GetTheloai), new { id = createdTheloai.Id }, createdTheloai);
    }

    // PUT: api/Theloai/5
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateTheloai(string id, TheloaiUpdateDTO theloaiDto)
    {
        try
        {
            await _theloaiService.UpdateAsync(id, theloaiDto);
            return NoContent();
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }

    // DELETE: api/Theloai/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteTheloai(string id)
    {
        try
        {
            await _theloaiService.DeleteAsync(id);
            return NoContent();
        }
        catch (KeyNotFoundException)
        {
            return NotFound();
        }
    }
} 