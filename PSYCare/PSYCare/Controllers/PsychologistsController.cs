using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
using PSYCare.Services.Interfaces;
using PSYCare.Services.Models;

namespace PSYCare.Controllers;

[ApiController]
[Route("[controller]")]
public class PsychologistsController : ControllerBase
{
    private readonly IPsychologistsService _psychologistsService;

    public PsychologistsController(IPsychologistsService psychologistsService)
    {
        _psychologistsService = psychologistsService;
    }

    [HttpPost("add-psychologist")]
    public async Task<IActionResult> CreatePsychologist([FromBody] CreatePsychologistRequest request)
    {
        if (request is null)
            return BadRequest();

        var psychologist = await _psychologistsService.CreatePsychologistAsync(MapToServiceModel(request));

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

        return patients is null
            ? NotFound()
            : Ok(patients);
    }

    [HttpGet("get-all")]
    public async Task<IActionResult> GetAllPsychologists()
    {
        var psychologists = await _psychologistsService.GetAllPsychologistsAsync();
        return Ok(psychologists);
    }

    private static Psychologist MapToServiceModel(CreatePsychologistRequest request) =>
        new()
        {
            Email = request.Email,
            Name = request.Name,
            Location = request.Location,
            Password = request.Password
        };
}