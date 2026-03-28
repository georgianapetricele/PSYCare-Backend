using Microsoft.EntityFrameworkCore;
using PSYCare.Database;
using PSYCare.Services.Interfaces;
using PSYCare.Services.Models;
using DbPsychologist = PSYCare.Database.Entities.Psychologist;

namespace PSYCare.Services;

public class PsychologistsService : IPsychologistsService
{
    private readonly PSYCareDbContext _context;

    public PsychologistsService(PSYCareDbContext context)
    {
        _context = context;
    }

    public async Task<Psychologist?> GetPsychologistByIdAsync(int userId)
    {
        var dbUser = await _context.Psychologists.FindAsync(userId);

        return dbUser is null
            ? null
            : MapToServiceModel(dbUser);
    }

    public async Task<List<Patient>?> GetPatientsForPsychologist(int id)
    {
        var patients = await _context.Patients
            .Where(p => p.PsychologistId == id)
            .Select(p => MapToPatientModel(p))
            .ToListAsync();

        return patients.Count == 0 ? null : patients;
    }

    public async Task<Psychologist?> CreatePsychologistAsync(Psychologist user)
    {
        var dbUser = MapToDbModel(user);

        _context.Psychologists.Add(dbUser);
        await _context.SaveChangesAsync();

        return MapToServiceModel(dbUser);
    }

    public async Task<List<Psychologist>> GetAllPsychologistsAsync() =>
        await _context.Psychologists
            .Select(p => MapToServiceModel(p))
            .ToListAsync();

    // ------------------ Mapping Methods ------------------

    private static Psychologist MapToServiceModel(DbPsychologist dbUser) =>
        new()
        {
            Id = dbUser.Id,
            Email = dbUser.Email,
            Name = dbUser.Name,
            Location = dbUser.Location
        };

    private static DbPsychologist MapToDbModel(Psychologist user) =>
        new()
        {
            Email = user.Email,
            Name = user.Name,
            Location = user.Location,
            Password = user.Password
        };

    private static Patient MapToPatientModel(Database.Entities.Patient p) =>
        new()
        {
            Id = p.Id,
            Email = p.Email,
            Name = p.Name,
            PhoneNumber = p.PhoneNumber,
            Location = p.Location,
            IssueDescription = p.IssueDescription,
            Age = p.Age
        };
}