using Microsoft.EntityFrameworkCore;
using PSYCare.Database.Entities;

namespace PSYCare.Database;

public class PSYCareDbContext : DbContext
{
    public PSYCareDbContext(DbContextOptions<PSYCareDbContext> options)
        : base(options)
    {
    }

    public DbSet<Patient> Patients { get; set; }
    public DbSet<Psychologist> Psychologists { get; set; }
    public DbSet<MoodEntry> MoodEntries { get; set; } = default!;
    public DbSet<Session> Sessions { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.ApplyConfigurationsFromAssembly(
            typeof(PSYCareDbContext).Assembly
        );

        modelBuilder.Entity<MoodEntry>(b =>
        {
            b.ToTable("mood_entries");
            b.HasKey(x => x.Id);

            b.Property(x => x.Score).IsRequired();

            b.Property(x => x.CreatedAt)
                .HasDefaultValueSql("now()");

            b.HasIndex(x => new { x.PatientId, x.CreatedAt });

            b.HasOne(x => x.Patient)
                .WithMany(p => p.MoodEntries)
                .HasForeignKey(x => x.PatientId)
                .OnDelete(DeleteBehavior.Cascade);
        });
    }
}
