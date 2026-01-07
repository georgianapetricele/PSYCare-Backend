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
        public ICollection<Pacient> Pacients { get; set; } = new List<Pacient>();
    }
}
