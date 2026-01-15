using Microsoft.EntityFrameworkCore;
using PSYCare.Controllers.Models;
using PSYCare.Database.Entities;
using PSYCare.Database;
using PSYCare.Services;
using DbPatient = PSYCare.Database.Entities.Patient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSYCare.Test
{
    [TestFixture]
    // TC-J-01, TC-J-02, TC-J-03, TC-J-04, TC-J-05, TC-J-06
    // - JournalService methods: CreateAsync, ListAsync, UpdateAsync, DeleteAsync
    // - PSYCareDbContext 
    // - Validates behavior: creation, listing, updating, deletion
    internal class JournalTests
    {
        private PSYCareDbContext _context;
        private JournalService _service;

        [SetUp]
        public void Setup()
        {
            var options = new DbContextOptionsBuilder<PSYCareDbContext>()
                .UseInMemoryDatabase(databaseName: "JournalTestDb")
                .Options;

            _context = new PSYCareDbContext(options);

            _context.Patients.RemoveRange(_context.Patients);
            _context.JournalEntries.RemoveRange(_context.JournalEntries);
            _context.SaveChanges();

            // Add a test patient
            _context.Patients.Add(new DbPatient { Id = 1, Email = "test@test.com", Name = "Test Patient", Password = "1234" , PhoneNumber = "numbver" });
            _context.SaveChanges();

            _service = new JournalService(_context);
        }

        [TearDown]
        public void TearDown() => _context.Dispose();

        [Test]
        public async Task CreateAsync_ShouldCreateEntry()
        {
            var dto = new JournalEntryCreateDto("My first entry");

            var result = await _service.CreateAsync(1, dto);

            Assert.IsNotNull(result);
            Assert.AreEqual("My first entry", result.Text);
            Assert.AreEqual(1, result.Id); // First entry ID in InMemory DB
        }

        [Test]
        public void CreateAsync_NonExistingPatient_ThrowsKeyNotFoundException()
        {
            var dto = new JournalEntryCreateDto("Entry");

            Assert.ThrowsAsync<KeyNotFoundException>(async () =>
            {
                await _service.CreateAsync(999, dto);
            });
        }

        [Test]
        public async Task ListAsync_ShouldReturnEntriesInDescendingOrder()
        {
            // Arrange
            _context.JournalEntries.AddRange(
                new JournalEntry { Id = 1, PatientId = 1, Text = "First", CreatedAt = DateTimeOffset.UtcNow.AddHours(-1) },
                new JournalEntry { Id = 2, PatientId = 1, Text = "Second", CreatedAt = DateTimeOffset.UtcNow }
            );
            _context.SaveChanges();

            // Act
            var result = await _service.ListAsync(1);

            // Assert
            Assert.AreEqual(2, result.Count);
            Assert.AreEqual("Second", result[0].Text);
            Assert.AreEqual("First", result[1].Text);
        }

        [Test]
        public async Task UpdateAsync_ShouldUpdateText()
        {
            _context.JournalEntries.Add(new JournalEntry { Id = 1, PatientId = 1, Text = "Old Text", CreatedAt = DateTimeOffset.UtcNow });
            _context.SaveChanges();

            var dto = new JournalEntryCreateDto("Updated Text");
            await _service.UpdateAsync(1, 1, dto);

            var updated = await _context.JournalEntries.FindAsync(1);
            Assert.AreEqual("Updated Text", updated.Text);
        }

        [Test]
        public async Task DeleteAsync_ShouldRemoveEntry()
        {
            _context.JournalEntries.Add(new JournalEntry { Id = 1, PatientId = 1, Text = "Delete Me", CreatedAt = DateTimeOffset.UtcNow });
            _context.SaveChanges();

            await _service.DeleteAsync(1, 1);

            var deleted = await _context.JournalEntries.FindAsync(1);
            Assert.IsNull(deleted);
        }

        [Test]
        public void DeleteAsync_NonExistingEntry_ThrowsKeyNotFoundException()
        {
            Assert.ThrowsAsync<KeyNotFoundException>(async () =>
            {
                await _service.DeleteAsync(1, 999);
            });
        }
    }
}

