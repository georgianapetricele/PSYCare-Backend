using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
using PSYCare.Database.Entities;
using PSYCare.Services.Interfaces;
using PSYCare.Services.Models;

namespace PSYCare.Controllers;

[ApiController]
[Route("[controller]")]
public class UsersController : ControllerBase
{
    IUsersService _usersService;

    public UsersController(IUsersService usersService)
    {
        _usersService = usersService;
    }

    [HttpGet]
    [Route("get-user/{id}")]
    public async Task<IActionResult> GetUserById(int id)
    {
        var psychologist = await _usersService.GetPsychologistByIdAsync(id);
        if (psychologist == null)
        {
            var pacient = await _usersService.GetPacientByIdAsync(id);
            if (pacient != null)
                return Ok(new
                {
                    type = "pacient",
                    data = pacient
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

    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginRequest request)
    {
        var result = await _usersService.LoginAsync(request.Email, request.Password);

        if (result == null)
            return Unauthorized();

        return Ok(result);
    }

    [HttpPost]
    [Route("add-psychologist")]
    public async Task<IActionResult> CreatePshchologist([FromBody] CreatePsychologistRequest request)
    {
        var user = new Services.Models.Psychologist
        {
            Email = request.Email,
            Name = request.Name,
            Location = request.Location,
            Password = request.Password,
        };

        var psychologist = await _usersService.CreatePsychologistAsync(user);
        return Ok(new
        {
            type = "psychologist",
            data = psychologist
        });
    }

    [HttpPost]
    [Route("add-pacient")]
    public async Task<IActionResult> CreatePacient([FromBody] CreatePacientRequest request)
    {
        var user = new Services.Models.Pacient
        {
            Email = request.Email,
            Name = request.Name,
            Location = request.Location,
            PhoneNumber = request.PhoneNumber,
            Faculty = request.Faculty,
            Password = request.Password,
            Problem = request.Problem,
            Age = request.Age
        };

        var pacient = await _usersService.CreatePacientAsync(user);
        return Ok(new
        {
            type = "pacient",
            data = pacient
        });
    }
}
