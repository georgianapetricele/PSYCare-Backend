using PSYCare.Database;
using PSYCare.Services.Interfaces;
using PSYCare.Services.Models;
using DbPatient = PSYCare.Database.Entities.Patient;

namespace PSYCare.Services;

public class PatientsService: IPatientsService
{
    private readonly PSYCareDbContext _context;

    public PatientsService(PSYCareDbContext context)
    {
        _context = context;
    }

    public async Task<Patient?> GetPatientByIdAsync(int userId)
    {
        var dbUser = await _context.Patients.FindAsync(userId);

        if (dbUser == null)
        {
            return null;
        }

        return new Patient
        {
            Email = dbUser.Email,
            Name = dbUser.Name,
            PhoneNumber = dbUser.PhoneNumber,
            Location = dbUser.Location,
            IssueDescription = dbUser.IssueDescription,
            Age = dbUser.Age
        };
    }

    public async Task<Patient?> CreatePatientAsync(Patient user)
    {
        var dbUser = new DbPatient
        {
            Email = user.Email,
            Name = user.Name,
            PhoneNumber = user.PhoneNumber,
            Location = user.Location,
            IssueDescription = user.IssueDescription,
            Age = user.Age,
            Password = user.Password
        };

        _context.Patients.Add(dbUser);
        await _context.SaveChangesAsync();

        // map DB -> Service model
        return new Patient
        {
            Id = dbUser.Id, // ID generat de PostgreSQL
            Email = dbUser.Email,
            Name = dbUser.Name,
            PhoneNumber = dbUser.PhoneNumber,
            Location = dbUser.Location,
            IssueDescription = dbUser.IssueDescription,
            Age = dbUser.Age
        };
    }
}
