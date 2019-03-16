namespace tms.api.Model
{
    public class Address
    {
        public int Id { get; set; }

        public string Unit { get; set; }

        public string Number { get; set; }

        public string StreetName { get; set; }

        public string Suburb { get; set; }

        public string State { get; set; }

        public string Country { get; set; }

        public decimal Longtitude { get; set; }

        public decimal Latitude { get; set; }

        public string CompleteAddress {
            get {
                if (string.IsNullOrEmpty(Unit))
                    return string.Format("{0} {1} {2}, {3}", Number, StreetName, Suburb, State);
                else
                    return string.Format("{0}/{1} {2}, {3}, {4}", Unit, Number, StreetName, Suburb, State);
            }
        }

        public string GpsAddress
        {
            get
            {
                return string.Format("{0} {1}, {2}, {3}, {4}", Number, StreetName, Suburb, State, Country);
            }
        }

        public int DistanceMeterFromOrigin { get; set; }

        public int DurationSecondFromOrigin { get; set; }

        public int DistanceMeterFromPrevious { get; set; }

        public int DurationSecondFromPrevious { get; set; }


        public string DistanceFromOriginDesc { get; set; }

        public string DurationFromOriginDesc { get; set; }

        public string DistanceFromPreviousDesc { get; set; }

        public string DurationFromPreviousDesc { get; set; }
    }
}