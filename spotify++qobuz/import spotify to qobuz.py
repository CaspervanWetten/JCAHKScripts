import requests
import json

# Authorization token that must have been created previously. See : https://developer.spotify.com/documentation/web-api/concepts/authorization
token = 'BQAODkcUKAUMXf8mFqrPZ5spfxYIRQOIxb8AW4jrt2CC7ejC09dJJ_oE9hL1oDh81lmIYo8niSU5IToLe_vYOXv_IWGa_5PcGZsgCE3kAGSEdYh0adpS7h3UNlMZpCjXF_W9V8tthFIULVMOQUgLApP3NHtAowgmZuauO8Ftj_gJUZkrwAYPW9yekTe_0nflFZIWY_qLnPEZNQBmrH3rS9GyBvnp06-3aPkK0qCIohsBx7LSuzpQ-zLwW8X7Fv9a8N6HM94X_khvcUnYp3mKJYZGmsI'

def fetchWebApi(endpoint, method, body):
    res = requests.request(method, f'https://api.spotify.com/{endpoint}', headers={'Authorization': f'Bearer {token}'}, json=body)
    return res.json()

tracksUri = [
  'spotify:track:4WM1hvYr2NC6bQnQXcj3sH','spotify:track:5wWS4an0mIaKgsARgACpP3','spotify:track:01YKzjsShT3cbontmqrkHP','spotify:track:5kKfOamJeKOkLDkxP6j3Pr','spotify:track:7v9VgPcjy7gPRsHZjKPUhU','spotify:track:7JIGukN75OW1Oa6EdfwC9g','spotify:track:1YgDGKyKhFlimPw3mLavPG','spotify:track:6JTmZ1zBuBYnZI1nHTIAQy','spotify:track:0rFGpzZJM4gveQPlusXtGX','spotify:track:5O3zrFjUqXI2mUcKF4wEo9'
]
user_id = 'ja.van.otterlo'

def createPlaylist(tracksUri):
    playlist = fetchWebApi(f'v1/users/{user_id}/playlists', 'POST', {
        "name": "My recommendation playlist",
        "description": "Playlist created by the tutorial on developer.spotify.com",
        "public": False
    })
    fetchWebApi(f'v1/playlists/{playlist["id"]}/tracks?uris={",".join(tracksUri)}', 'POST')
    return playlist

createdPlaylist = createPlaylist(tracksUri)
print(createdPlaylist['name'], createdPlaylist['id'])