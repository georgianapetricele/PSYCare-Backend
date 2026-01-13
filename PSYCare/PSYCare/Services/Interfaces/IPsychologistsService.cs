using PSYCare.Services.Models;

namespace PSYCare.Services.Interfaces;

public interface IPsychologistsService
{
    Task<Psychologist?> GetPsychologistByIdAsync(int userId);
    Task<Psychologist?> CreatePsychologistAsync(Psychologist user);
    Task<List<Patient>?> GetPatientsForPsychologist(int Id);
    Task<List<Psychologist>> GetAllPsychologistsAsync();
}
