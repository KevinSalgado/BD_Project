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
