using PSYCare.Services.Models;

namespace PSYCare.Services.Interfaces;

public interface IPatientsService
{
    Task<Patient?> GetPatientByIdAsync(int userId);
    Task<Patient?> CreatePatientAsync(Patient user);
    Task<Psychologist?> GetPsychologistForPatientAsync(int patientId);
    Task<bool> AssignPsychologistToPatientAsync(int patientId, string psychologistEmail);
    Task<bool> DeletePatientAsync(int patientId);

    Task<Patient?> UpdatePatientAsync(int patientId, string diagnosis, string psychologistNotes);
}
