using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using PSYCare.Database.Entities;

namespace PSYCare.Database.Configurations;

public class PsychologistConfiguration: IEntityTypeConfiguration<Psychologist>
{
    public void Configure(EntityTypeBuilder<Psychologist> builder)
    {

        builder.Property(x => x.Email)
               .IsRequired()
               .HasMaxLength(256);

        builder.HasIndex(x => x.Email)
               .IsUnique();

        builder.Property(x => x.Name)
                .IsRequired()
                .HasMaxLength(100);

        builder.HasMany(p => p.Patients)
           .WithOne(patient => patient.Psychologist)
           .HasForeignKey(patient => patient.PsychologistId)
           .IsRequired(false);
    }
}

