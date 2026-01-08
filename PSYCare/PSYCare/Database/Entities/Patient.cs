namespace PSYCare.Database.Entities;

public class Patient
{
    public int Id { get; set; } 
    public int? PsychologistId { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
    public string Password { get; set; }
    public string PhoneNumber { get; set; }
    public string? Location { get; set; }
    public string? IssueDescription { get; set; }
    public int Age { get; set; }

    public Psychologist? Psychologist { get; set; }
}