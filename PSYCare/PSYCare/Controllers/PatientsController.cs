using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
using PSYCare.Services;
using PSYCare.Services.Interfaces;

namespace PSYCare.Controllers;

[ApiController]
[Route("[controller]")]
public class PatientsController(IPatientsService patientsService, IMoodService moodService, IJournalService journalService) : ControllerBase
{
    private readonly IPatientsService _patientsService = patientsService;
    private readonly IMoodService _moodService = moodService;
    private readonly IJournalService _journalService = journalService;

    [HttpPost("add-patient")]
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
        return Ok(new { type = "patient", data = patient });
    }

    [HttpGet("get-patient/{patientId}")]
    public async Task<IActionResult> GetPatientById(int patientId)
    {
        var patient = await _patientsService.GetPatientByIdAsync(patientId);
        return patient is null ? NotFound() : Ok(patient);
    }

    [HttpPut("update-patient/{patientId}")]
    public async Task<IActionResult> UpdatePatient(int patientId, [FromBody] UpdatePatientRequest request)
    {
        var updatedPatient = await _patientsService.UpdatePatientAsync(patientId, request.Diagnosis, request.PsychologistNotes);
        return updatedPatient is null
            ? NotFound()
            : Ok(new { type = "patient", data = updatedPatient });
    }

    [HttpGet("{patientId}/get-psychologist")]
    public async Task<IActionResult> GetPsychologistForPatient(int patientId)
    {
        var psychologist = await _patientsService.GetPsychologistForPatientAsync(patientId);
        return psychologist is null ? NotFound() : Ok(psychologist);
    }

    [HttpDelete("delete-patient/{patientId}")]
    public async Task<IActionResult> DeletePatient(int patientId)
    {
        if (!await _patientsService.DeletePatientAsync(patientId))
        {
            return NotFound();
        }
        return Ok(new { message = "Patient deleted successfully." });
    }

    [HttpPost("{patientId}/assign-psychologist")]
    public async Task<IActionResult> AssignPsychologistToPatient(int patientId, [FromBody] AssignPsychologistRequest request)
    {
        if (!await _patientsService.AssignPsychologistToPatientAsync(patientId, request.PsychologistEmail))
        {
            return NotFound("Patient or Psychologist not found.");
        }

        return Ok(new { message = "Psychologist assigned successfully." });
    }

    [HttpPost("{patientId}/moods")]
    public Task<IActionResult> CreateMood(int patientId, [FromBody] MoodEntryCreateDto dto)
        => SafeExecute(async () =>
        {
            var created = await _moodService.CreateAsync(patientId, dto);
            return CreatedAtAction(nameof(GetMoods), new { patientId }, created);
        });

    [HttpGet("{patientId}/moods")]
    public async Task<ActionResult<IReadOnlyList<MoodEntryResponseDto>>> GetMoods(int patientId, [FromQuery] int limit = 50)
    {
        var list = await _moodService.ListAsync(patientId, limit);
        return Ok(list);
    }

    [HttpPut("{patientId}/moods/{moodId}")]
    public Task<IActionResult> UpdateMood(int patientId, int moodId, [FromBody] MoodEntryCreateDto dto)
        => SafeExecute(async () =>
        {
            await _moodService.UpdateAsync(patientId, moodId, dto);
            return NoContent();
        });

    [HttpDelete("{patientId}/moods/{moodId}")]
    public Task<IActionResult> DeleteMood(int patientId, int moodId)
        => SafeExecute(async () =>
        {
            await _moodService.DeleteAsync(patientId, moodId);
            return NoContent();
        });

    [HttpPost("{patientId}/journals")]
    public Task<IActionResult> CreateJournal(int patientId, [FromBody] JournalEntryCreateDto dto)
        => SafeExecute(async () =>
        {
            var created = await _journalService.CreateAsync(patientId, dto);
            return CreatedAtAction(nameof(GetJournals), new { patientId }, created);
        });

    [HttpGet("{patientId}/journals")]
    public async Task<ActionResult<IReadOnlyList<JournalEntryResponseDto>>> GetJournals(int patientId, [FromQuery] int limit = 50)
    {
        var list = await _journalService.ListAsync(patientId, limit);
        return Ok(list);
    }

    [HttpPut("{patientId}/journals/{journalId}")]
    public Task<IActionResult> UpdateJournal(int patientId, int journalId, [FromBody] JournalEntryCreateDto dto)
        => SafeExecute(async () =>
        {
            await _journalService.UpdateAsync(patientId, journalId, dto);
            return NoContent();
        });

    [HttpDelete("{patientId}/journal/{journalId}")]
    public Task<IActionResult>
        DeleteJournal(int patientId, int journalId)
        => SafeExecute(async () =>
        {
            await _journalService.DeleteAsync(patientId, journalId);
            return NoContent();
        });

    private static async Task<IActionResult> SafeExecute(Func<Task<IActionResult>> action)
    {
        try
        {
            return await action();
        }
        catch (ArgumentException ex) { return new BadRequestObjectResult(ex.Message); }
        catch (KeyNotFoundException ex) { return new NotFoundObjectResult(ex.Message); }
    }
}