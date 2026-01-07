using Microsoft.AspNetCore.Mvc;
using PSYCare.Controllers.Models;
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
        var user = await _usersService.GetUserByIdAsync(id);
        if (user == null)
        {
            return NotFound();
        }
        return Ok(user);
    }

    [HttpPost]
    [Route("add-user")]
    public async Task<IActionResult> CreateUser([FromBody] CreateUserRequest request)
    {
        var user = new User
        {
            Email = request.Email,
            Name = request.Name
        };

        await _usersService.CreateUserAsync(user);
        return Ok();
    }
}
