{% docs event_types %}

Table provides a mapping between unique event type identifiers (`type_id`) and their descriptive names (`type`). It is essential for converting numerical codes from user activity logs into readable descriptions for analysis of user interactions with application features.

The table is crucial for analytics and reporting, allowing for the decoding of event identifiers in user activity datasets. By joining with event logs, it facilitates intuitive reporting and dashboarding of user interactions. The mapping enables effective segmentation and analysis of user activities, such as:

- **start_search**: Represents the initiation of a search process by a user.
- **book_scooter**: Indicates that a user has booked a scooter.
- **release_scooter**: Signifies that a user has released a previously booked scooter.
- **cancel_search**: Denotes the cancellation of a search process by a user.

{% enddocs %}
