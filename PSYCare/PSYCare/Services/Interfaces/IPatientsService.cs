using PSYCare.Services.Models;

namespace PSYCare.Services.Interfaces;

public interface IPatientsService
{
    Task<Patient?> GetPatientByIdAsync(int userId);
    Task<Patient?> CreatePatientAsync(Patient user);
    Task<Psychologist?> GetPsychologistForPatientAsync(int patientId);
    Task<bool> AssignPsychologistToPatientAsync(int patientId, string psychologistEmail);
}
