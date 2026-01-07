using PSYCare.Services.Models;

namespace PSYCare.Services.Interfaces;

public interface IUsersService
{
    Task<Pacient?> GetPacientByIdAsync(int userId);
    Task<Psychologist?> GetPsychologistByIdAsync(int userId);
    Task<Pacient?> CreatePacientAsync(Pacient user);
    Task<Psychologist?> CreatePsychologistAsync(Psychologist user);
    Task<object?> LoginAsync(string email, string password);
}
