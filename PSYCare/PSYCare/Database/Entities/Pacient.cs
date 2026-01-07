namespace PSYCare.Database.Entities;

public class Pacient
{
    public int Id { get; set; } 
    public string Name { get; set; }
    public string Email { get; set; }
    public string Password { get; set; }
    public string PhoneNumber { get; set; }
    public string? Faculty { get; set; }
    public string? Location { get; set; }
    public string? Problem { get; set; }
    public int Age { get; set; }
}