# Relational Model

**Conference** (<u>id</u>, name [NN], acronym [NN], description)

**Edition** (<u>id</u>, #conference → Conference [NN], year [NN], start_date [NN], end_date [NN], location [NN])<br>
&nbsp;&nbsp;{UK: conference, year}<br>
&nbsp;&nbsp;CHECK (start_date <= end_date)

**Participant** (<u>id</u>, name [NN], email [NN, UK], affiliation)

**Participates** (<u>#edition → Edition</u>, <u>#participant → Participant</u>)

**Activity** (<u>id</u>, title [NN], description, start_ts [NN], end_ts [NN], #edition → Edition [NN])<br>
&nbsp;&nbsp;{UK: id, edition}<br>
&nbsp;&nbsp;CHECK (start_ts < end_ts)

**Involvement** (<u>participant</u>, <u>activity</u>, edition [NN], role [NN])<br>
&nbsp;&nbsp;#(activity, edition) → Activity (id, edition)<br>
&nbsp;&nbsp;#(edition, participant) → Participates (edition, participant)

**RegistrationType** (<u>id</u>, #edition → Edition [NN], name [NN], fee [NN])<br>
&nbsp;&nbsp;{UK: edition, name}<br>
&nbsp;&nbsp;{UK: id, edition}<br>
&nbsp;&nbsp;CHECK (fee >= 0)

**Registration** (<u>id</u>, participant [NN], registration_type [NN], edition [NN], registration_date [NN], status [NN])<br>
&nbsp;&nbsp;{UK: participant, edition}<br>
&nbsp;&nbsp;#(registration_type, edition) → RegistrationType (id, edition)<br>
&nbsp;&nbsp;#(edition, participant) → Participates (edition, participant)<br>
&nbsp;&nbsp;CHECK (status IN ('pending', 'confirmed', 'cancelled'))

**Payment** (<u>id</u>, #registration → Registration [NN], amount [NN], payment_date [NN], payment_method [NN], status [NN])<br>
&nbsp;&nbsp;CHECK (amount > 0)<br>
&nbsp;&nbsp;CHECK (status IN ('pending', 'completed', 'refunded'))

**Enrollable** (<u>#id → Activity</u>, max_capacity, fee [NN], registration_required [NN])<br>
&nbsp;&nbsp;CHECK (fee >= 0)<br>
&nbsp;&nbsp;CHECK (max_capacity IS NULL OR max_capacity > 0)

**SocialEvent** (<u>#id → Enrollable</u>, location [NN])

**OrganisedActivity** (<u>#id → Enrollable</u>, activity_type [NN])<br>
&nbsp;&nbsp;CHECK (activity_type IN ('workshop', 'tutorial'))

**Enrolment** (<u>participant</u>, <u>#enrollable → Enrollable</u>, edition [NN], enroll_date [NN])<br>
&nbsp;&nbsp;#(enrollable, edition) → Activity (id, edition)<br>
&nbsp;&nbsp;#(edition, participant) → Participates (edition, participant)

**Organises** (<u>participant</u>, <u>#organised_activity → OrganisedActivity</u>, edition [NN])<br>
&nbsp;&nbsp;#(organised_activity, edition) → Activity (id, edition)<br>
&nbsp;&nbsp;#(edition, participant) → Participates (edition, participant)
