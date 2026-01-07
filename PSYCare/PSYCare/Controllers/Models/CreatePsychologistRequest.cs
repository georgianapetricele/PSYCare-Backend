namespace PSYCare.Controllers.Models;

public class CreatePsychologistRequest
{
    public string Email { get; set; }
    public string Password { get; set; }
    public string Name { get; set; }
    public string? Location { get; set; }
}
