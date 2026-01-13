using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
using PSYCare.Services.Interfaces;

namespace PSYCare.Controllers;

[ApiController]
[Route("[controller]")]
public class PsychologistsController: ControllerBase
{

    IPsychologistsService _psychologistsService;

    public PsychologistsController(IPsychologistsService psychologistsService)
    {
        _psychologistsService = psychologistsService;
    }

    [HttpPost]
    [Route("add-psychologist")]
    public async Task<IActionResult> CreatePsychologist([FromBody] CreatePsychologistRequest request)
    {
        var user = new Services.Models.Psychologist
        {
            Email = request.Email,
            Name = request.Name,
            Location = request.Location,
            Password = request.Password,
        };

        var psychologist = await _psychologistsService.CreatePsychologistAsync(user);
        return Ok(new
        {
            type = "psychologist",
            data = psychologist
        });
    }

    [HttpGet("get-patients/{psychologistId}")]
    public async Task<IActionResult> GetPatientsForPsychologist(int psychologistId)
    {
        var patients = await _psychologistsService.GetPatientsForPsychologist(psychologistId);
        if (patients == null)
        {
            return NotFound();
        }
        return Ok(patients);
    }

    [HttpGet("get-all")]
    public async Task<IActionResult> GetAllPsychologists()
    {
        var psychologists = await _psychologistsService.GetAllPsychologistsAsync();
        return Ok(psychologists);
    }
}
