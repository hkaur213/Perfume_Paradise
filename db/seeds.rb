require 'httparty'
require 'uri'
require 'open-uri'
require 'faker'

Province.create([
  { name: "Ontario", abbreviation: "ON" },
  { name: "British Columbia", abbreviation: "BC" },
  { name: "Quebec", abbreviation: "QC" },
  { name: "Alberta", abbreviation: "AB" },
  { name: "Manitoba", abbreviation: "MB" },
  { name: "Saskatchewan", abbreviation: "SK" },
  { name: "Nova Scotia", abbreviation: "NS" },
  { name: "New Brunswick", abbreviation: "NB" },
  { name: "Prince Edward Island", abbreviation: "PE" },
  { name: "Newfoundland and Labrador", abbreviation: "NL" },
  { name: "Northwest Territories", abbreviation: "NT" },
  { name: "Yukon", abbreviation: "YT" },
  { name: "Nunavut", abbreviation: "NU" }
])
