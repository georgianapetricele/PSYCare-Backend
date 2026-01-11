using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
using PSYCare.Services;
using PSYCare.Services.Interfaces;

namespace PSYCare.Controllers;

[ApiController]
[Route("[controller]")]
public class PatientsController: ControllerBase
{
    IPatientsService _patientsService;
    private readonly IMoodService _moodService;
    private readonly IJournalService _journalService;


    public PatientsController(IPatientsService patientsService, IMoodService moodService, IJournalService journalService)
    {
        _patientsService = patientsService;
        _moodService = moodService;
        _journalService = journalService;
    }

    [HttpPost]
    [Route("add-patient")]
    public async Task<IActionResult> CreatePatient([FromBody] CreatePatientRequest request)
    {
        var user = new Services.Models.Patient
        {
            Email = request.Email,
            Name = request.Name,
            Location = request.Location,
            PhoneNumber = request.PhoneNumber,
            Password = request.Password,
            IssueDescription = request.IssueDescription,
            Age = request.Age
        };

        var patient = await _patientsService.CreatePatientAsync(user);
        return Ok(new
        {
            type = "patient",
            data = patient
        });
    }

    [HttpGet("{patientId}/get-psychologist")]
    public async Task<IActionResult> GetPsychologistForPatient(int patientId)
    {
        var psychologist = await _patientsService.GetPsychologistForPatientAsync(patientId);
        if (psychologist == null)
        {
            return NotFound();
        }
        return Ok(psychologist);
    }

    [HttpPost("{patientId}/assign-psychologist")]
    public async Task<IActionResult> AssignPsychologistToPatient(int patientId, [FromBody] AssignPsychologistRequest request)
    {
        var psychologistEmail = request.PsychologistEmail;
        var ok = await _patientsService.AssignPsychologistToPatientAsync(patientId, psychologistEmail);
        
        if (!ok)
        {
            return NotFound("Patient or Psychologist not found.");
        }

        return Ok(new { message = "Psychologist assigned successfully." });
    }

    [HttpPost("{patientId}/moods")]
    public async Task<ActionResult<MoodEntryResponseDto>> CreateMood(int patientId, [FromBody] MoodEntryCreateDto dto)
    {
        try
        {
            var created = await _moodService.CreateAsync(patientId, dto);
            return CreatedAtAction(nameof(GetMoods), new { patientId }, created);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(ex.Message);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(ex.Message);
        }
    }

    [HttpGet("{patientId}/moods")]
    public async Task<ActionResult<IReadOnlyList<MoodEntryResponseDto>>> GetMoods(int patientId, [FromQuery] int limit = 50)
    {
        var list = await _moodService.ListAsync(patientId, limit);
        return Ok(list);
    }

    [HttpPut("{patientId}/moods/{moodId}")]
    public async Task<IActionResult> UpdateMood(int patientId, int moodId, [FromBody] MoodEntryCreateDto dto)
    {
        try
        {
            await _moodService.UpdateAsync(patientId, moodId, dto);
            return NoContent();
        }
        catch (ArgumentException ex)
        {
            return BadRequest(ex.Message);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(ex.Message);
        }
    }

    [HttpDelete("{patientId}/moods/{moodId}")]
    public async Task<IActionResult> DeleteMood(int patientId, int journalId)
    {
        try
        {
            await _moodService.DeleteAsync(patientId, journalId);
            return NoContent();
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(ex.Message);
        }
    }

    [HttpPost("{patientId}/journals")]
    public async Task<ActionResult<JournalEntryResponseDto>> CreateJournal(int patientId, [FromBody] JournalEntryCreateDto dto)
    {
        try
        {
            var created = await _journalService.CreateAsync(patientId, dto);
            return CreatedAtAction(nameof(GetJournals), new { patientId }, created);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(ex.Message);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(ex.Message);
        }
    }

    [HttpGet("{patientId}/journals")]
    public async Task<ActionResult<IReadOnlyList<MoodEntryResponseDto>>> GetJournals(int patientId, [FromQuery] int limit = 50)
    {
        var list = await _journalService.ListAsync(patientId, limit);
        return Ok(list);
    }

    [HttpPut("{patientId}/journals/{journalId}")]
    public async Task<IActionResult> UpdateJournal(int patientId, int journalId, [FromBody] JournalEntryCreateDto dto)
    {
        try
        {
            await _journalService.UpdateAsync(patientId, journalId, dto);
            return NoContent();
        }
        catch (ArgumentException ex)
        {
            return BadRequest(ex.Message);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(ex.Message);
        }
    }

    [HttpDelete("{patientId}/journal/{journalId}")]
    public async Task<IActionResult> DeleteJournal(int patientId, int journalId)
    {
        try
        {
            await _journalService.DeleteAsync(patientId, journalId);
            return NoContent();
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(ex.Message);
        }
    }
}
