using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.EntityFrameworkCore;
using PSYCare.Database;
using PSYCare.Services.Interfaces;
using PSYCare.Services.Models;
using DbPatient = PSYCare.Database.Entities.Patient;

namespace PSYCare.Services;

public class PatientsService(PSYCareDbContext context) : IPatientsService
{
    public async Task<Patient?> GetPatientByIdAsync(int userId)
    {
        var dbUser = await context.Patients.FindAsync(userId);
        return dbUser is null ? null : MapToModel(dbUser);
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

        context.Patients.Add(dbUser);
        await context.SaveChangesAsync();

        return MapToModel(dbUser);
    }

    public async Task<Psychologist?> GetPsychologistForPatientAsync(int patientId)
    {
        return await context.Patients
            .Where(p => p.Id == patientId)
            .Select(p => p.Psychologist == null ? null : new Psychologist
            {
                Email = p.Psychologist.Email,
                Name = p.Psychologist.Name,
                Location = p.Psychologist.Location
            })
            .FirstOrDefaultAsync();
    }

    public async Task<bool> DeletePatientAsync(int patientId)
    {
        var patient = await context.Patients.FindAsync(patientId);
        if (patient is null)
        {
            return false;
        }

        patient.PsychologistId = null;
        await context.SaveChangesAsync();
        return true;
    }

    public async Task<bool> AssignPsychologistToPatientAsync(int patientId, string psychologistEmail)
    {
        var patient = await context.Patients.FindAsync(patientId);
        if (patient is null)
        {
            return false;
        }

        var psychologist = await context.Psychologists
            .FirstOrDefaultAsync(p => p.Email == psychologistEmail);

        if (psychologist is null)
        {
            return false;
        }

        patient.PsychologistId = psychologist.Id;
        await context.SaveChangesAsync();

        return true;
    }

    public async Task<Patient?> UpdatePatientAsync(int patientId, string? diagnosis, string? psychologistNotes)
    {
        var patient = await context.Patients.FindAsync(patientId);
        if (patient is null)
        {
            return null;
        }

        if (diagnosis is not null) patient.Diagnosis = diagnosis;
        if (psychologistNotes is not null) patient.PsychologistNotes = psychologistNotes;

        await context.SaveChangesAsync();
        return MapToModel(patient);
    }

    private static Patient MapToModel(DbPatient dbUser) => new()
    {
        Id = dbUser.Id,
        Email = dbUser.Email,
        Name = dbUser.Name,
        PhoneNumber = dbUser.PhoneNumber,
        Location = dbUser.Location,
        PsychologistId = dbUser.PsychologistId,
        IssueDescription = dbUser.IssueDescription,
        Age = dbUser.Age,
        Diagnosis = dbUser.Diagnosis,
        PsychologistNotes = dbUser.PsychologistNotes
    };
}