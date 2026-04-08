using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
using PSYCare.Services.Interfaces;

namespace PSYCare.Controllers;

[ApiController]
[Route("[controller]")]
public class PatientsController(IPatientsService patientsService) : ControllerBase
{
    private readonly IPatientsService _patientsService = patientsService;

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
        var diagnosis = request.Diagnosis ?? string.Empty;
        var psychologistNotes = request.PsychologistNotes ?? string.Empty;

        var updatedPatient = await _patientsService.UpdatePatientAsync(patientId, diagnosis, psychologistNotes);
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
}
