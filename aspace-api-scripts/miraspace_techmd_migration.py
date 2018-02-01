# This script uses the ArchivesSpace API to add file-level technical metadata to pre-existing Digital Object Components.
# The metadata comes from an exif output file, and a database dump from ASpace is used as a crosswalk to make API calls.

import requests
import json
import sys


def main():
    # read in exif data and create a list of lists
    exif_list = []
    exif_file = 'collectionexif.csv'
    exif_in = open(exif_file, 'r')
    exif_contents = exif_in.read()
    exif_data = exif_contents.splitlines()
    for line in exif_data:
        data = line.split(',')
        exif_list.append(data)
    exif_in.close()
    # read in the database dump and append the primary key to the appropriate line of the exif list.
    db_dump = 'dao_labels.csv'
    db_in = open(db_dump, 'r')
    db_contents = db_in.read()
    db_data = db_contents.splitlines()
    for line in db_data:
        fields = line.split(',')
        for entry in exif_list:
            if fields[1] in entry[1]:
                entry.append(fields[0])
    db_in.close()
    # set up variables for making ASpace API calls
    aspace_url = 'XXXXXX'
    username = 'XXXXXX'
    password = 'XXXXXX'
    auth = requests.post(aspace_url + '/users/' + username + '/login?password=' + password).json()
    session = auth['session']
    headers = {'X-ArchivesSpace-Session': session}
    # pull down DO components one at a time to edit JSON and re-post
    for entry in exif_list:
        try:
            item_pk = entry[9]
        except IndexError:
            print("Something's funny - " + entry[1] + " doesn't have a primary key.")
            sys.exit()
        component_json = requests.get(aspace_url + '/repositories/2/digital_object_components/' + item_pk, headers=headers).json()
        # only add technical metadata to the archival version of the file
        for version in component_json['file_versions']:
            # * IMPORTANT should say "archive image" instead of reference for every collection other than commencement.
            if version['use_statement'] == 'reference image':
                version['checksum_method'] = 'md5'
                version['checksum'] = entry[2]
                version['file_size_bytes'] = int(entry[3])
                version['file_format_name'] = str.lower(entry[4])
        component_json['notes'] = []
        component_json['notes'].append(note_builder(entry[5], 'pixel dimensions'))
        component_json['notes'].append(note_builder(entry[6], 'resolution'))
        component_json['notes'].append(note_builder(entry[7], 'bits per sample'))
        component_json['notes'].append(note_builder(entry[8], 'color space'))
        repost_data = json.dumps(component_json)
        component_post = requests.post(aspace_url + '/repositories/2/digital_object_components/' + item_pk,
                                       headers=headers, data=repost_data).json()
        print(component_post)


def note_builder(list_index, label_value):
    note_text = {'jsonmodel_type':'note_digital_object', 'publish':False, 'content':[list_index], 'type':'note',
                 'label':label_value}
    return note_text


main()
