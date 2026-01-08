using Microsoft.EntityFrameworkCore;
using PSYCare.Database;
using PSYCare.Services.Interfaces;

namespace PSYCare.Services;

public class AuthService: IAuthService
{
    private readonly PSYCareDbContext _context;

    public AuthService(PSYCareDbContext context)
    {
        _context = context;
    }

    public async Task<object?> LoginAsync(string email, string password)
    {
        var pacient = await _context.Patients
            .FirstOrDefaultAsync(x => x.Email == email && x.Password == password);

        if (pacient != null)
            return new { role = "pacient", data = pacient };

        var psychologist = await _context.Psychologists
            .FirstOrDefaultAsync(x => x.Email == email && x.Password == password);

        if (psychologist != null)
            return new { role = "psychologist", data = psychologist };

        return null;
    }
}
