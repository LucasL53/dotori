from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build
import datetime
import os

# If modifying these SCOPES, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/calendar']

# output = {
#   "summary": "DUBHACKS ’23 - Beyond Imaginable",
#   "location": "University of Washington, Seattle",
#   "description": "Explore limitless imagination in tech's ever-changing world. Join us at ‘Beyond Imaginable,’ the largest collegiate hackathon in the PNW, where boundaries blur and possibilities bloom. DubHacks hosts the next-gen of tech leaders from across the globe, all united to solve the pressing challenges of our generation. Let's shape the future together. What will you build?",
#   "start": {
#     "dateTime": "2023-10-14T00:00:00",
#     "timeZone": "America/Los_Angeles"
#   },
#   "end": {
#     "dateTime": "2023-10-15T23:59:59",
#     "timeZone": "America/Los_Angeles"
#   },
#   "reminders": {
#     "useDefault": false,
#     "overrides": [
#       {
#         "method": "popup",
#         "minutes": 30
#       }
#     ]
#   }
# }

def authenticate_google_calendar():
    creds = None
    # The file token.json stores the user's access and refresh tokens,
    # and is created automatically when the authorization flow completes
    # for the first time.
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json')
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.json', 'w') as token:
            token.write(creds.to_json())
    return creds

def create_event(summary, description, start_datetime, end_datetime, location):
    creds = authenticate_google_calendar()
    service = build('calendar', 'v3', credentials=creds)

    # Define event details
    event = {
        'summary': summary,
        'description': description,
        'start': {
            'dateTime': start_datetime,
            'timeZone': 'America/Los_Angeles',
        },
        'end': {
            'dateTime': end_datetime,
            'timeZone': 'America/Los_Angeles',
        },
        'location': location,
        'reminders': {
            'useDefault': False,
            'overrides': [
                {'method': 'popup', 'minutes': 60},
                {'method': 'popup', 'minutes': 10},
            ],
        },
    }

    # Call the Calendar API
    event = service.events().insert(calendarId='primary', body=event).execute()
    print('Event created: %s' % (event.get('htmlLink')))

if __name__ == '__main__':
    # Call create_event with your specific event details
    create_event(
        summary='DUBHACK \'23',
        description='Explore limitless imagination in tech\'s ever-changing world. Join us at \'Beyond Imaginable,\' the largest collegiate hackathon in the PNW, where boundaries blur and possibilities bloom. ',
        start_datetime='2023-10-14T00:00:00',
        end_datetime='2023-10-15T23:59:59',
        location='University of Washington, Seattle'
    )