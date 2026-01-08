using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace PSYCare.Migrations
{
    /// <inheritdoc />
    public partial class AddRelationPatientPsychologist : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Pacients");

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Psychologists",
                type: "character varying(100)",
                maxLength: 100,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.AlterColumn<string>(
                name: "Email",
                table: "Psychologists",
                type: "character varying(256)",
                maxLength: 256,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "text");

            migrationBuilder.CreateTable(
                name: "Patients",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    PsychologistId = table.Column<int>(type: "integer", nullable: false),
                    Name = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Email = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                    Password = table.Column<string>(type: "text", nullable: false),
                    PhoneNumber = table.Column<string>(type: "text", nullable: false),
                    Faculty = table.Column<string>(type: "text", nullable: true),
                    Location = table.Column<string>(type: "text", nullable: true),
                    Problem = table.Column<string>(type: "text", nullable: true),
                    Age = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Patients", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Patients_Psychologists_PsychologistId",
                        column: x => x.PsychologistId,
                        principalTable: "Psychologists",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Psychologists_Email",
                table: "Psychologists",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Patients_Email",
                table: "Patients",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Patients_PsychologistId",
                table: "Patients",
                column: "PsychologistId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Patients");

            migrationBuilder.DropIndex(
                name: "IX_Psychologists_Email",
                table: "Psychologists");

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Psychologists",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(100)",
                oldMaxLength: 100);

            migrationBuilder.AlterColumn<string>(
                name: "Email",
                table: "Psychologists",
                type: "text",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "character varying(256)",
                oldMaxLength: 256);

            migrationBuilder.CreateTable(
                name: "Pacients",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Age = table.Column<int>(type: "integer", nullable: false),
                    Email = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: false),
                    Faculty = table.Column<string>(type: "text", nullable: true),
                    Location = table.Column<string>(type: "text", nullable: true),
                    Name = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Password = table.Column<string>(type: "text", nullable: false),
                    PhoneNumber = table.Column<string>(type: "text", nullable: false),
                    Problem = table.Column<string>(type: "text", nullable: true),
                    PsychologistId = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Pacients", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Pacients_Psychologists_PsychologistId",
                        column: x => x.PsychologistId,
                        principalTable: "Psychologists",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Pacients_Email",
                table: "Pacients",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Pacients_PsychologistId",
                table: "Pacients",
                column: "PsychologistId");
        }
    }
}
