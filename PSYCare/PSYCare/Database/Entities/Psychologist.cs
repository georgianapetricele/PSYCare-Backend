namespace PSYCare.Database.Entities
{
    public class Psychologist
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string? Location { get; set; }

        // Navigation property: one psychologist can have many patients
        public ICollection<Patient> Patients { get; set; } = new List<Patient>();
    }
}
