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
        var patient = await context.Patients
            .FirstOrDefaultAsync(x => x.Email == email && x.Password == password);

        if (patient is not null)
        {
            return new { role = "patient", data = patient };
        }

        var psychologist = await context.Psychologists
            .FirstOrDefaultAsync(x => x.Email == email && x.Password == password);

        return psychologist is not null
            ? new { role = "psychologist", data = psychologist }
            : null;
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