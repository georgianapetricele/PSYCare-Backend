using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.EntityFrameworkCore;
using PSYCare.Database;
using PSYCare.Services.Interfaces;
using PSYCare.Services.Models;
using DbPatient = PSYCare.Database.Entities.Patient;

namespace PSYCare.Services;

public class PatientsService : IPatientsService
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
            PsychologistId = dbUser.PsychologistId,
            IssueDescription = dbUser.IssueDescription,
            Diagnosis = dbUser.Diagnosis,
            PsychologistNotes = dbUser.PsychologistNotes,
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

    public async Task<Psychologist?> GetPsychologistForPatientAsync(int patientId)
    {
        var psychologist = await _context.Patients
            .Where(p => p.Id == patientId)
            .Select(p => p.Psychologist)
            .FirstOrDefaultAsync();

        if (psychologist == null)
            return null;

        return new Psychologist
        {
            Email = psychologist.Email,
            Name = psychologist.Name,
            Location = psychologist.Location
        };
    }

    public async Task<bool> DeletePatientAsync(int patientId)
    {
        var patient = await _context.Patients.FindAsync(patientId);
        if (patient == null)
        {
            return false;
        }
        patient.PsychologistId = null;
        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<bool> AssignPsychologistToPatientAsync(int patientId, string psychologistEmail)
    {
        var patient = await _context.Patients.FindAsync(patientId);
        if (patient == null)
        {
            return false;
        }

        var psychologist = await _context.Psychologists
            .FirstOrDefaultAsync(p => p.Email == psychologistEmail);

        if (psychologist == null)
        {
            return false;
        }

        patient.PsychologistId = psychologist.Id;
        await _context.SaveChangesAsync();

        return true;
    }

    public async Task<Patient?> UpdatePatientAsync(int patientId, string diagnosis, string psychologistNotes)
    {
        var patient = await _context.Patients.FindAsync(patientId);
        if (patient == null)
        {
            return null;
        }
       
        patient.
    }
}