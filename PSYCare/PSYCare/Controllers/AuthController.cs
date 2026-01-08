using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
using PSYCare.Services.Interfaces;

namespace PSYCare.Controllers;

[ApiController]
[Route("[controller]")]
public class AuthController : ControllerBase
{
    IAuthService _authService;
    IPatientsService _patientsService;
    IPsychologistsService _psychologistsService;

    public AuthController(IAuthService authService, IPatientsService patientsService, IPsychologistsService psychologistsService)
    {
        _authService = authService;
        _patientsService = patientsService;
        _psychologistsService = psychologistsService;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var result = await _authService.LoginAsync(request.Email, request.Password);

        if (result == null)
            return Unauthorized();

        return Ok(result);
    }


    [HttpGet]
    [Route("get-user/{id}")]
    public async Task<IActionResult> GetUserById(int id)
    {
        var psychologist = await _psychologistsService.GetPsychologistByIdAsync(id);
        if (psychologist == null)
        {
            var patient = await _patientsService.GetPatientByIdAsync(id);
            if (patient != null)
                return Ok(new
                {
                    type = "patient",
                    data = patient
                });
            else
                return NotFound();
        }
        else
        {
            return Ok(new
            {
                type = "psychologist",
                data = psychologist
            });
        }
    }
}
