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
       var patient = await _context.Patients
            .FirstOrDefaultAsync(x => x.Email == email && x.Password == password);

        if (patient != null)
            return new { role = "patient", data = patient };

        var psychologist = await _context.Psychologists
            .FirstOrDefaultAsync(x => x.Email == email && x.Password == password);

        if (psychologist != null)
            return new { role = "psychologist", data = psychologist };

        return null;
    }
}
