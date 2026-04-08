using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
using PSYCare.Services.Interfaces;

namespace PSYCare.Controllers;

[ApiController]
[Route("[controller]")]
public class AuthController(IAuthService authService) : ControllerBase
{
    private readonly IAuthService _authService = authService;

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var result = await _authService.LoginAsync(request.Email, request.Password);
        return result is null ? Unauthorized() : Ok(result);
    }

    [HttpGet("get-user/{id}")]
    public async Task<IActionResult> GetUserById(int id)
    {
        var result = await _authService.GetUserByIdAsync(id);
        return result is null ? NotFound() : Ok(result);
    }
}