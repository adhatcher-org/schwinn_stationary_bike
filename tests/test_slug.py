"""Tests for slug fixtures."""

import pytest


@pytest.fixture
def slug():
    """Return a sample slug for testing."""
    return "test-slug-123"


@pytest.fixture
def valid_slug():
    """Return a valid slug for testing."""
    return "valid-slug-for-testing"


@pytest.fixture
def invalid_slug():
    """Return an invalid slug for testing."""
    return "invalid slug with spaces"


def test_slug_fixture(slug):
    """Test that the slug fixture returns a valid slug."""
    assert isinstance(slug, str)
    assert len(slug) > 0
    assert "test-slug-123" == slug


def test_valid_slug_fixture(valid_slug):
    """Test that the valid_slug fixture returns a valid slug."""
    assert isinstance(valid_slug, str)
    assert len(valid_slug) > 0
    assert "valid-slug-for-testing" == valid_slug


def test_invalid_slug_fixture(invalid_slug):
    """Test that the invalid_slug fixture returns an invalid slug."""
    assert isinstance(invalid_slug, str)
    assert len(invalid_slug) > 0
    assert "invalid slug with spaces" == invalid_slug


def test_slug_contains_expected_elements(slug, valid_slug):
    """Test that slugs contain expected elements."""
    assert "-" in slug
    assert "-" in valid_slug