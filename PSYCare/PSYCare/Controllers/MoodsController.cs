using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
using PSYCare.Services.Interfaces;

namespace PSYCare.Controllers;

[ApiController]
[Route("patients/{patientId}/moods")]
public class MoodsController(IMoodService moodService) : ControllerBase
{
    private readonly IMoodService _moodService = moodService;

    [HttpPost]
    public async Task<IActionResult> CreateMood(int patientId, [FromBody] MoodEntryCreateDto dto)
    {
        var created = await _moodService.CreateAsync(patientId, dto);
        return CreatedAtAction(nameof(GetMoods), new { patientId }, created);
    }

    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<MoodEntryResponseDto>>> GetMoods(int patientId, [FromQuery] int limit = 50)
    {
        var list = await _moodService.ListAsync(patientId, limit);
        return Ok(list);
    }

    [HttpPut("{moodId}")]
    public async Task<IActionResult> UpdateMood(int patientId, int moodId, [FromBody] MoodEntryCreateDto dto)
    {
        await _moodService.UpdateAsync(patientId, moodId, dto);
        return NoContent();
    }

    [HttpDelete("{moodId}")]
    public async Task<IActionResult> DeleteMood(int patientId, int moodId)
    {
        await _moodService.DeleteAsync(patientId, moodId);
        return NoContent();
    }
}
