namespace PSYCare.Services.Models
{
    public class Psychologist
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string? Location { get; set; }

        public List<Patient> Pacients { get; set; } = new List<Patient>();
    }
}
