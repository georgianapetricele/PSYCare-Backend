using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
using PSYCare.Services;

namespace PSYCare.Controllers;

[ApiController]
[Route("patients/{patientId}/journals")]
public class JournalsController(IJournalService journalService) : ControllerBase
{
    private readonly IJournalService _journalService = journalService;

    [HttpPost]
    public async Task<IActionResult> CreateJournal(int patientId, [FromBody] JournalEntryCreateDto dto)
    {
        var created = await _journalService.CreateAsync(patientId, dto);
        return CreatedAtAction(nameof(GetJournals), new { patientId }, created);
    }

    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<JournalEntryResponseDto>>> GetJournals(int patientId, [FromQuery] int limit = 50)
    {
        var list = await _journalService.ListAsync(patientId, limit);
        return Ok(list);
    }

    [HttpPut("{journalId}")]
    public async Task<IActionResult> UpdateJournal(int patientId, int journalId, [FromBody] JournalEntryCreateDto dto)
    {
        await _journalService.UpdateAsync(patientId, journalId, dto);
        return NoContent();
    }

    [HttpDelete("{journalId}")]
    public async Task<IActionResult> DeleteJournal(int patientId, int journalId)
    {
        await _journalService.DeleteAsync(patientId, journalId);
        return NoContent();
    }
}
