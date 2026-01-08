using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
using PSYCare.Services.Interfaces;

namespace PSYCare.Controllers;

[ApiController]
[Route("[controller]")]
public class PatientsController: ControllerBase
{
    IPatientsService _patientsService;
    private readonly IMoodService _moodService;


    public PatientsController(IPatientsService patientsService, IMoodService moodService)
    {
        _patientsService = patientsService;
        _moodService = moodService;
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

        var pacient = await _patientsService.CreatePatientAsync(user);
        return Ok(new
        {
            type = "pacient",
            data = pacient
        });
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
    public async Task<IActionResult> DeleteMood(int patientId, int moodId)
    {
        try
        {
            await _moodService.DeleteAsync(patientId, moodId);
            return NoContent();
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(ex.Message);
        }
    }
}
