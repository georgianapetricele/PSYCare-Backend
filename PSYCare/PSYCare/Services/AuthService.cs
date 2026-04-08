using Microsoft.EntityFrameworkCore;
using PSYCare.Database;
using PSYCare.Services.Interfaces;

namespace PSYCare.Services;

public class AuthService(
    PSYCareDbContext context,
    IPatientsService patientsService,
    IPsychologistsService psychologistsService) : IAuthService
{
    public async Task<object?> LoginAsync(string email, string password)
    {
        return (object?)await context.Patients
            .Where(x => x.Email == email && x.Password == password)
            .Select(x => new { role = "patient", data = x })
            .FirstOrDefaultAsync()
            ?? await context.Psychologists
            .Where(x => x.Email == email && x.Password == password)
            .Select(x => new { role = "psychologist", data = x })
            .FirstOrDefaultAsync();
    }

    public async Task<object?> GetUserByIdAsync(int id)
    {
        var psychologist = await psychologistsService.GetPsychologistByIdAsync(id);
        if (psychologist is not null)
        {
            return new { type = "psychologist", data = psychologist };
        }

        var patient = await patientsService.GetPatientByIdAsync(id);
        if (patient is not null)
        {
            return new { type = "patient", data = patient };
        }

        return null;
    }
}