namespace PSYCare.Controllers.Models
{
    public class CreatePatientRequest
    {
        public string Name { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string PhoneNumber { get; set; }
        public string? Faculty { get; set; }
        public string? Location { get; set; }
        public string? IssueDescription { get; set; }
        public int Age { get; set; }
    }
}
