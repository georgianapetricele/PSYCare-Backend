using PSYCare.Database;
using PSYCare.Services.Interfaces;
using PSYCare.Services.Models;
using DbPsychologist = PSYCare.Database.Entities.Psychologist;

namespace PSYCare.Services;

public class PsychologistsService: IPsychologistsService
{
    private readonly PSYCareDbContext _context;

    public PsychologistsService(PSYCareDbContext context)
    {
        _context = context;
    }

    public async Task<Psychologist?> GetPsychologistByIdAsync(int userId)
    {
        var dbUser = await _context.Psychologists.FindAsync(userId);

        if (dbUser == null)
        {
            return null;
        }

        return new Psychologist
        {
            Email = dbUser.Email,
            Name = dbUser.Name,
            Location = dbUser.Location,
        };
    }

    public async Task<Psychologist?> CreatePsychologistAsync(Psychologist user)
    {
        var dbUser = new DbPsychologist
        {
            Email = user.Email,
            Name = user.Name,
            Location = user.Location,
            Password = user.Password
        };

        _context.Psychologists.Add(dbUser);
        await _context.SaveChangesAsync();

        // map DB → Service model
        return new Psychologist
        {
            Id = dbUser.Id, // ID generat de DB
            Email = dbUser.Email,
            Name = dbUser.Name,
            Location = dbUser.Location
        };
    }

}
