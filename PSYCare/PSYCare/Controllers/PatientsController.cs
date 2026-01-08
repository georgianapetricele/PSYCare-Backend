using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
using PSYCare.Services.Interfaces;

namespace PSYCare.Controllers;

[ApiController]
[Route("[controller]")]
public class PatientsController: ControllerBase
{
    IPatientsService _patientsService;

    public PatientsController(IPatientsService patientsService)
    {
        _patientsService = patientsService;
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

}
